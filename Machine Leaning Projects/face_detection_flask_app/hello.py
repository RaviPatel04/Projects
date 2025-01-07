from flask import Flask, request
from markupsafe import escape
from flask import url_for
from flask import render_template
from flask import redirect,url_for

app = Flask(__name__)

# @app.route("/")
# @app.route('/hello/')
# @app.route('/<name>')
# def hello(name=None):
#     return render_template('hello.html', person=name)

@app.route("/")
def welcome():
    return render_template("results.html")
@app.route("/pass/<int:marks>")
def passed(marks):
    return render_template("final.html", marks = marks)
    # return "Your marks is "+ str(marks) +" Congratulations!! have cleared the exam!!"


@app.route("/fail/<int:marks>")
def fail(marks):
    return render_template("final.html", marks = marks)
    # return "Your marks is "+ str(marks) +" Sorry!! Better luck next time!!"

@app.route("/range/")
def range():
    return "Marks should be range from 0 to 100"

@app.route("/results",methods = ["GET", "POST"])
def result():
    if request.method == "POST":
        physics = float(request.form["physics"])
        chemistry = float(request.form["chemistry"])
        maths = float(request.form["maths"])
        score = (physics+chemistry+maths)/3
    if score<33:
        result = "fail"
    elif score>100:
        result = "range"
    else:
        result = "passed"
    
    return redirect(url_for(result, marks = score))

if __name__ == '__main__':
    app.run(debug=True)