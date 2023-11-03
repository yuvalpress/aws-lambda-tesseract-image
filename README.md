# aws-lambda-tesseract-image
<img src="images/GitHub-logo.png"></img></br>

#### An AWS lambda-based image with tesseract installed on it. </br> 
More on Tesseract OCR: <a href=https://github.com/tesseract-ocr/tesseract>Tesseract OCR GitHub repository.</a>

### Using the base-image

To use the already built base image, use the `FROM` command to retrieve the image from the `yuvalpress/aws-lambda-tesseract`  repository.

For a detailed example, look under the `Dockerfile-from-base` file in the repository's root folder.

### Lambda Configuration
**Recommended Settings:**
1. Set Lambda's timeout to `60 seconds`. </br>
Usually it takes up to `30 seconds` to extract text from an image with Tesseract in a **cheap** Lambda-based environment, but lets stay on the safe side.

2. Set memory limit to `512M` for faster execution times, but `256M` is also sufficient.
