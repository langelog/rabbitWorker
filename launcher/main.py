from launcher.handlers import handle_message
import os
import pika

def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters(
        host=os.environ["QUEUE_HOST"],
        credentials=pika.PlainCredentials(
            username=os.environ["QUEUE_USER"],
            password=os.environ["QUEUE_PASS"],
        ),
    ))
    channel = connection.channel()

    channel.queue_declare(os.environ["SERVICE"], durable=True, auto_delete=False)

    channel.basic_consume(queue=os.environ["SERVICE"], on_message_callback=handle_message, auto_ack=True)

    print(" [*] Waiting for messages.")
    channel.start_consuming()

if __name__ == "__main__":
    exit(main())
