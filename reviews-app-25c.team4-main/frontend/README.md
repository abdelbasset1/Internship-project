# Frontend Application README

## Overview
This is the frontend application for the Review Application, a simple web service that allows users to add and view products and their reviews. The application communicates with the backend application to fetch and display product details and their associated reviews. The frontend application is built using HTML, CSS, and JavaScript, and it's served using Nginx.

## Features
- Users can add new products and provide their names.
- Users can add reviews for existing products.
- Users can view a list of all products and their reviews.
- The application fetches AI-generated sentiment scores (Polarity and Subjectivity) for each review from the backend and displays them along with the review.

## Prerequisites
- Nginx or any other HTTP web server that can serve static files for web hosting.

## Installation
- Install web server package such as `nginx` or `httpd`
- Make sure to replace baseurl value of `'http://reviews-api.exchangeweb.net:80'` in the `app.js` file with the actual DNS name of the backend application.
- Place the html, css, javascript files into a web server directory from which a website is hosted (ex: `/usr/share/nginx/html`)
- Run the web server application (ex: `systemctl start nginx`)
<img width="563" alt="Reviews-App-Frontend-Page" src="https://github.com/312-bc/reviews-app-base/assets/43100287/ea3933f4-6c6e-4b02-8bda-0a2eb0ed826d">


## Troubleshooting
Once you open frontend webpage from browser, it should display options to add products, reviews, and should show reviews once you add them. If these features are not working - check for errors in Chrome Console:

- right click somewhere on the chrome browser page while you have site open => Inspect => Console => errors should show up here (some errors can be ignored, but pay attention to connection errors to backend if you see any)
