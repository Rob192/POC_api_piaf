# BOT Service Public
This chat bot is the first implementation of the service public chat bot.\
 It uses rasa open source and request the haystack API available [here](https://piaf.datascience.etalab.studio/docs). 

## DEVELOPMENT 
### INSTALL 

`pip install -r requirements.txt`

`python -m spacy download fr_core_news_sm`

`python -m spacy link fr_core_news_sm fr`
### RUN
`rasa run actions`

`rasa train`

`rasa shell` 

## DEPLOY
### SET UP SSL
With you domain name ready : 

`sudo certbot certonly --standalone`

Move certificates to the rasa folder :

`#Inside your project directory`

`mkdir certs` 

`sudo cp /etc/letsencrypt/<domain>/live/fullchain.pem ./certs`

`sudo cp /etc/letsencrypt/<domain>/live/privkey.pem ./certs`

### NGINX
Modify Nginx configuration with your domain name 

### credentials
Add the credentials for the service your are aiming by modifying `credentials.yml`

