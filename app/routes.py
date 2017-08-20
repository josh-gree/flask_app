# coding=utf-8

from flask import render_template, flash, redirect, session, url_for, request, g, Markup
from app import app

import subprocess

@app.route('/')
@app.route('/index')
def index():
    python_location = subprocess.check_output(['which','python'])
    python_version = subprocess.check_output(['python','--version'])
    return render_template('index.html',python_version=python_version,python_location=python_location)

@app.route('/about')
def about():
    return render_template('about.html')




