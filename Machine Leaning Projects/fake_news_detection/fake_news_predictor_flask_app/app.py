from flask import Flask, request, render_template,url_for
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib
import re
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
import nltk



nltk.download('stopwords')

app = Flask(__name__)

# Load the trained model and vectorizer
model = joblib.load('fake_news_model.joblib')
vector = joblib.load('tfidf_vectorizer.joblib')

ps = PorterStemmer()

def stemnews(news):
    stem_words = re.sub('[^a-zA-Z]', ' ', news)
    stem_words = stem_words.lower()
    stem_words = stem_words.split()
    stem_words = [ps.stem(word) for word in stem_words if not word in stopwords.words("english")]
    stem_words = ' '.join(stem_words)
    return stem_words

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        news = request.form['news']
        processed_news = stemnews(news)
        vectorized_news = vector.transform([processed_news])
        prediction = model.predict(vectorized_news)[0]
        result = "Fake News" if prediction == 1 else "Real News"
        return render_template('index.html', prediction=result, news=news)

if __name__ == '__main__':
    app.run(debug=True)