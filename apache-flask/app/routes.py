# coding=utf-8

### HELLO
import flask
from flask import render_template, flash, redirect, session, url_for, request, g, Markup
from app import app

import platform

@app.route('/')
@app.route('/index')
def index():
    return render_template('index.html',python_version=platform.python_version(),flask_location = flask.__file__)

@app.route('/about')
def about():
    return render_template('about.html')




