from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from bs4 import BeautifulSoup
import time

app = Flask(__name__)

# Function to scrape Yahoo Sports using Selenium
def scrape_yahoo_sports():
    # Specify the path to the ChromeDriver
    chrome_driver_path = '/path/to/chromedriver'  # Replace with the correct path to your chromedriver
    service = Service(chrome_driver_path)

    # Initialize the WebDriver using the Service
    driver = webdriver.Chrome(service=service)
    driver.get('https://sports.yahoo.com/')  # Load the page

    # Wait for the page to load fully (adjust sleep time if necessary)
    time.sleep(5)

    # Get the page source after JavaScript has executed
    html = driver.page_source

    # Now parse the page with BeautifulSoup
    soup = BeautifulSoup(html, 'html.parser')

    # Close the driver after the page source is retrieved
    driver.quit()

    # Extract articles as before
    articles = []
    for item in soup.find_all('li', class_='js-stream-content Pos(r) YahooSans Fw(400)!'):
        # Extract image URL
        image_tag = item.find('img', class_='W(100%)')
        image_url = image_tag['src'] if image_tag else None

        # Extract title, link, and description
        title_tag = item.find('h3')
        title = title_tag.get_text(strip=True) if title_tag else None
        
        link_tag = title_tag.find('a') if title_tag else None
        article_url = link_tag['href'] if link_tag else None
        
        description_tag = item.find('p')
        description = description_tag.get_text(strip=True) if description_tag else None

        # Extract source and time
        source_and_time = item.find('div', class_='C(#959595) Fz(11px) D(ib) Mb(6px)')
        if source_and_time:
            source_tag = source_and_time.find('span')
            source = source_tag.get_text(strip=True) if source_tag else None

            time_tag = source_tag.find_next_sibling('span') if source_tag else None
            time_ago = time_tag.get_text(strip=True) if time_tag else None
        else:
            source = None
            time_ago = None

        # Append the article data to the list
        articles.append({
            'title': title,
            'url': article_url,
            'image': image_url,
            'description': description,
            'source': source,
            'time_ago': time_ago
        })

    return articles

@app.route('/scrape', methods=['GET'])
def get_scraped_data():
    articles = scrape_yahoo_sports()
    return jsonify(articles)

if __name__ == '__main__':
    app.run(debug=True)
