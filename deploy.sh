#!/bin/bash

cd "$(dirname "$0")/jekyll"
jekyll build
aws s3 sync _site/ s3://boxysean.com/
