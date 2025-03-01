import requests
import os
import random
import time
import logging

# Set up logging configuration
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)

# Unsplash API credentials
UNSPLASH_ACCESS_KEY = 'lgizRXGzlGoKBOp-8tHryeH77jfow0oZ5N-jwAIwSns'

# Directory to save the downloaded wallpaper (relative path)
DOWNLOAD_DIRECTORY = os.path.join(os.path.dirname(__file__), 'downloads')

# Function to check network connectivity
def check_network_connectivity():
    """
    Check if the device is connected to the internet.
    """
    try:
        response = requests.get('http://www.google.com', timeout=5)
        return response.status_code == 200
    except requests.RequestException as e:
        logging.error(f"Network connectivity check failed: {e}")
        return False

# Function to fetch a random wallpaper from Unsplash
def fetch_random_wallpaper(query=None, collection_id=None):
    """
    Fetch a random wallpaper from Unsplash with 4K resolution, falling back to 1080p if necessary.
    
    Args:
        query (str): Search query for specific wallpapers.
        collection_id (str): Collection ID to fetch wallpapers from a specific collection.
    
    Returns:
        str: URL of the wallpaper image.
    """
    if query:
        url = 'https://api.unsplash.com/search/photos'
        params = {
            'query': query,
            'orientation': 'landscape',
            'per_page': 50,
            'page': random.randint(1, 100),
            'content_filter': 'high'
        }
    else:
        url = 'https://api.unsplash.com/photos/random'
        params = {
            'orientation': 'landscape',
            'count': 1,
            'per_page': 50,
            'page': random.randint(1, 100),
            'content_filter': 'high'
        }
        if collection_id:
            params['collections'] = collection_id

    headers = {'Authorization': f'Client-ID {UNSPLASH_ACCESS_KEY}'}
    
    logging.info(f"Fetching wallpaper from Unsplash with params: {params}")
    
    response = requests.get(url, headers=headers, params=params)
    
    if response.status_code != 200:
        logging.error(f"Failed to fetch wallpaper from Unsplash: {response.status_code} {response.text}")
        raise Exception(f'Failed to fetch wallpaper from Unsplash: {response.status_code} {response.text}')
    
    data = response.json()
    
    if query:
        photos = data.get('results', [])
    else:
        photos = data if isinstance(data, list) else [data]
    
    # First, try to find 4K wallpapers (3840x2160 or higher)
    suitable_photos_4k = [photo for photo in photos if photo['width'] >= 3840 and photo['height'] >= 2160]
    
    if suitable_photos_4k:
        photo = random.choice(suitable_photos_4k)
        logging.info(f"Found suitable 4K wallpaper: {photo['urls']['full']}")
        return photo['urls']['full']
    
    # If no 4K wallpapers are found, fall back to 1080p wallpapers (1920x1080 or higher)
    suitable_photos_1080p = [photo for photo in photos if photo['width'] >= 1920 and photo['height'] >= 1080]
    
    if suitable_photos_1080p:
        photo = random.choice(suitable_photos_1080p)
        logging.warning(f"No 4K wallpapers found. Falling back to 1080p wallpaper: {photo['urls']['full']}")
        return photo['urls']['full']
    
    # If neither 4K nor 1080p wallpapers are found, raise an exception
    logging.error("No suitable wallpapers found with either 4K or 1080p resolution")
    raise Exception('No suitable wallpapers found with either 4K or 1080p resolution')

# Function to download the wallpaper
def download_wallpaper(image_url, file_path):
    """
    Download the wallpaper from the given URL and save it to the specified file path.
    
    Args:
        image_url (str): URL of the wallpaper image.
        file_path (str): Path to save the downloaded image.
    """
    logging.info(f"Downloading wallpaper from URL: {image_url}")
    
    response = requests.get(image_url)
    
    if response.status_code != 200:
        logging.error(f"Failed to download wallpaper: {response.status_code} {response.text}")
        raise Exception(f'Failed to download wallpaper: {response.status_code} {response.text}')
    
    with open(file_path, 'wb') as file:
        file.write(response.content)
    
    logging.info(f"Wallpaper downloaded successfully: {os.path.relpath(file_path, start=os.path.dirname(__file__))}")

# Main function
def main(search_query=None, collection_id=None):
    """
    Main function to fetch and download a wallpaper.
    
    Args:
        search_query (str): Search query for specific wallpapers.
        collection_id (str): Collection ID to fetch wallpapers from a specific collection.
    """
    # Check network connectivity for 1 minute
    for _ in range(12):  # 12 checks * 5 seconds = 1 minute
        if check_network_connectivity():
            break
        logging.warning("No network connection. Waiting for 5 seconds...")
        time.sleep(5)
    else:
        logging.error("Still no network connection after 1 minute. Exiting...")
        return
    
    try:
        # Ensure the download directory exists
        os.makedirs(DOWNLOAD_DIRECTORY, exist_ok=True)
        
        # Fetch the wallpaper URL
        image_url = fetch_random_wallpaper(query=search_query, collection_id=collection_id)
        
        # Download the wallpaper
        file_path = os.path.join(DOWNLOAD_DIRECTORY, 'wallpaper.jpg')
        download_wallpaper(image_url, file_path)
        
        logging.info(f"Wallpaper downloaded successfully: {os.path.relpath(file_path, start=os.path.dirname(__file__))}")
    
    except Exception as e:
        logging.error(f'Error: {e}')

# Run the main function
if __name__ == "__main__":
    # Example usage
    search_query = 'monochrome'  # Change this value to search for specific wallpapers or leave empty for random
    collection_id = ''  # Change this value to fetch from a specific collection or leave as None monochrome: '400620'
    main(search_query=search_query, collection_id=collection_id)
