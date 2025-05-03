import requests
from bs4 import BeautifulSoup
import json
import time
import random

def scrape_wikipedia_snippets():
    topics = [
        'Mathematics',
        'Physics',
        'Chemistry',
        'Biology',
        'Computer_science',
        'Engineering'
    ]
    
    snippets = []
    
    for topic in topics:
        url = f'https://en.wikipedia.org/wiki/{topic}'
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Get the first few paragraphs
        paragraphs = soup.find_all('p')[:5]
        
        for p in paragraphs:
            text = p.get_text().strip()
            if len(text) > 50:  # Only include meaningful content
                snippets.append({
                    'title': f'Interesting fact about {topic}',
                    'content': text,
                    'topic': topic.replace('_', ' '),
                    'difficulty': random.choice(['Beginner', 'Intermediate', 'Advanced']),
                    'readingTime': random.randint(15, 60),
                    'tags': [topic.replace('_', ' ').lower()]
                })
        
        time.sleep(1)  # Be nice to Wikipedia's servers
    
    return snippets

def save_to_json(snippets, filename='content_seed.json'):
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(snippets, f, ensure_ascii=False, indent=2)

def main():
    print('Scraping educational content from Wikipedia...')
    snippets = scrape_wikipedia_snippets()
    save_to_json(snippets)
    print(f'Saved {len(snippets)} snippets to content_seed.json')

if __name__ == '__main__':
    main() 