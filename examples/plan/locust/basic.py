import time
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def google(self):
        self.client.get("https://google.com")

    @task
    def microsoft(self):
        self.client.get("https://microsoft.com")
    
    @task
    def facebook(self):
        self.client.get("https://facebook.com")
