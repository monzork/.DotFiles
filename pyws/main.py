from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.keys import Keys
import time
import sys

wait = 1

script_name = sys.argv
contact = sys.argv[1]
message = sys.argv[2]

if contact is None:
    raise Exception("No contact added")

if message is None:
    raise Exception("No message added")

options = Options()
options.add_argument('--headless=new')
options.add_argument(
    "user-data-dir=C:\\Users\\malon\\AppData\\Local\\Google\\Chrome\\User Data")
driver = webdriver.Chrome(service=Service( ChromeDriverManager().install()), options=options) 
driver.get("https://web.whatsapp.com/")
driver.maximize_window()
text_area = ""

try:
    text_area = WebDriverWait(driver, 15).until(EC.presence_of_element_located((
        By.XPATH, "//*[@id=\"side\"]/div[1]/div/div/div[2]/div/div")))
    text_area.send_keys(contact)
    time.sleep(wait)
except TimeoutException:
    print("Loading took too much time!")


chat_name = driver.find_element(
    by="xpath", value="//*[@aria-selected=\"false\"]")
chat_name.click()
time.sleep(wait)

message_box = driver.find_element(
    by="xpath", value="//*[@id=\"main\"]/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div[1]")
message_box.send_keys(message)
message_box.send_keys(Keys.RETURN)


send_button = driver.find_element(
    by="xpath", value="//*[@id=\"main\"]/footer/div[1]/div/span[2]/div/div[2]/div[1]/div/div[1]")
time.sleep(1)
