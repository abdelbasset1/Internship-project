import requests
import random
import string

BASE_URL = 'http://reviews-api.example.com:80'  # Replace with your backend URL

# Generate random reviews
def generate_reviews(num_reviews):
    reviews = []
    for _ in range(num_reviews):
        review_content = ''.join(random.choices(string.ascii_letters + string.digits, k=100))
        reviews.append({'review': review_content})
    return reviews

# Submit reviews to the system
def submit_reviews(reviews):
    url = f"{BASE_URL}/product/1/review"  # Replace '1' with the appropriate product ID
    for review in reviews:
        response = requests.post(url, json=review)
        if response.status_code == 200:
            print("Review added successfully")
        else:
            print("Failed to add review")

# Generate and submit reviews
num_reviews = 20000  # Number of reviews to generate and submit
reviews = generate_reviews(num_reviews)
submit_reviews(reviews)
