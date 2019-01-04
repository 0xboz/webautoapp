#! /usr/bin/python3
# This test file is prepared for selenium setup used on DigitalOcean droplet

from pyvirtualdisplay import Display
from selenium import webdriver

display = Display(visible=0, size=(1920, 1080))
display.start()

options = webdriver.ChromeOptions()
options.add_argument('--no-sandbox')

driver = webdriver.Chrome(chrome_options=options)
driver.get('http://nytimes.com')
print(driver.title)
display.stop()
