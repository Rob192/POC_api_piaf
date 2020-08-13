# Extend the official Rasa SDK image
FROM rasa/rasa:1.10.8-full

# Use subdirectory as working directory
WORKDIR /

# Copy any additional custom requirements, if necessary (uncomment next line)
ADD requirements.txt requirements.txt

# Change back to root user to install dependencies
USER root

# Install extra requirements for actions code, if necessary (uncomment next line)
# RUN pip install -r requirements.txt
RUN python -m spacy download fr_core_news_sm
RUN python -m spacy link fr_core_news_sm fr


# Copy actions folder to working directory
COPY . .

# By best practices, don't run the code with root user
USER 1001