import pika
import json

class uwClient(object):
    
    def __init__(self, queue):
        self.connection = pika.BlockingConnection(
            pika.ConnectionParameters(
                host="localhost",
                credentials=pika.PlainCredentials(
                    username="guest",
                    password="guest",
                ),
            )
        )
        self.channel = self.connection.channel()
        self.channel.queue_declare(queue, durable=True, auto_delete=False)
        self.queue = queue

    def send(self, content):
        self.channel.basic_publish(
            exchange="",
            routing_key=self.queue,
            body=str.encode(json.dumps(content)),
        )
    