import os
import json
import boto3
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from textblob import TextBlob

app = Flask(__name__)
CORS(app)

# Retrieve database credentials from AWS SecretsManager
def get_db_credentials(secret_name="reviews-db-credentials-v5", region_name="us-east-1"):
    client = boto3.client('secretsmanager', region_name=region_name)
    try:
        response = client.get_secret_value(SecretId=secret_name)
        secret_data = json.loads(response['SecretString'])
        return secret_data
    except Exception as e:
        print(f"Warning: Could not fetch secret: {e}")
        raise

try:
    db_creds = get_db_credentials()
    app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{db_creds['DB_USERNAME']}:{db_creds['DB_PASSWORD']}@{db_creds['DB_ENDPOINT']}/{db_creds['DB_NAME']}"
    print("✅ Connected to RDS MySQL")
except Exception as e:
    print(f"⚠️ Error: {e}")
    app.config['SQLALCHEMY_DATABASE_URI'] = "sqlite:///:memory:"
    print("⚠️ Using SQLite fallback")

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    reviews = db.relationship('Review', backref='product', lazy=True)

class Review(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(200), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    polarity = db.Column(db.Float)
    subjectivity = db.Column(db.Float)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'}), 200

@app.route('/', methods=['GET'])
def index():
    return jsonify({'message': 'Reviews API is running'}), 200

@app.route('/product', methods=['POST'])
def add_product():
    try:
        product_name = request.json.get('product_name')
        if not product_name:
            return jsonify({'error': 'product_name is required'}), 400
        
        product = Product(name=product_name)
        db.session.add(product)
        db.session.commit()
        return jsonify({'message': 'Product added successfully', 'product_id': product.id}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/product', methods=['GET'])
def get_products():
    try:
        products = Product.query.all()
        return jsonify({'products': [{'id': product.id, 'name': product.name} for product in products]}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/product/<int:product_id>/review', methods=['POST'])
def add_review(product_id):
    try:
        review_content = request.json.get('review')
        if not review_content:
            return jsonify({'error': 'review content is required'}), 400

        # Sentiment analysis using TextBlob
        sentiment = TextBlob(review_content).sentiment
        polarity = sentiment.polarity
        subjectivity = sentiment.subjectivity

        review = Review(content=review_content, product_id=product_id, polarity=polarity, subjectivity=subjectivity)
        db.session.add(review)
        db.session.commit()
        return jsonify({
            'message': 'Review added successfully',
            'review_id': review.id,
            'polarity': polarity,
            'subjectivity': subjectivity
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/product/<int:product_id>/review', methods=['GET'])
def get_reviews(product_id):
    try:
        reviews = Review.query.filter_by(product_id=product_id).all()
        
        def convert_to_star_rating(polarity):
            # Convert polarity (-1.0 to 1.0) to star rating (1 to 10)
            star_rating = round(((polarity + 1.0) / 2.0) * 10)
            return star_rating
        
        return jsonify({
            'reviews': [
                {
                    'id': review.id,
                    'content': review.content,
                    'rating': convert_to_star_rating(review.polarity),
                    'subjectivity': review.subjectivity
                } for review in reviews
            ]
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Initialize database tables
with app.app_context():
    db.create_all()
    print("✅ Database tables initialized")

if __name__ == "__main__":
    app.run(debug=False, host='0.0.0.0', port=5000)