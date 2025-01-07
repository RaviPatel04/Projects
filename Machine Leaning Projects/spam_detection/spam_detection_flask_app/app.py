from flask import Flask, render_template, request, url_for
import joblib

app = Flask(__name__)

# Load the TF-IDF vectorizer and the model
vector = joblib.load("tfidf_vectorizer.joblib")
model = joblib.load("spam_news_model.joblib")

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/predict", methods=["POST"])
def predict():
    if request.method == "POST":
        sms = request.form["sms"]
        vectorizer_sms = vector.transform([sms])
        prediction = model.predict(vectorizer_sms)[0]
        result = "SPAM SMS" if prediction == 1 else "NOT SPAM SMS"
        return render_template("index.html", prediction=result, sms=sms)

if __name__ == '__main__':
    app.run(debug=True)
