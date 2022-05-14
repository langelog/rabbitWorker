from typing import Dict
import json
import pika
import service
import os


def reply(queue: str, content: Dict):
    print(f"Going to reply to: '{queue}'")
    print(f"Content: {json.dumps(content, indent=2)}")
    connection = pika.BlockingConnection(pika.ConnectionParameters(
        host=os.environ["QUEUE_HOST"],
        credentials=pika.PlainCredentials(
            username=os.environ["QUEUE_USER"],
            password=os.environ["QUEUE_PASS"],
        ),
    ))
    channel = connection.channel()
    channel.queue_declare(queue, durable=True, auto_delete=False)
    channel.basic_publish(
        exchange="",
        routing_key=queue,
        body=str.encode(json.dumps(content)),
    )

def handle_message(ch, method, properties, body):
    # Load and validate the request message
    try:
        request = json.loads(body)
        if "reply_to" not in request:
            raise Exception("request needs to have a 'reply_to' key")
        if "id" not in request:
            raise Exception("request needs to have a 'id' key")
        if "type" not in request:
            raise Exception("request needs to have a 'type' key")
    except Exception as e:
        print("failed to start on the request:", str(e))
        return
    # ask service to process this request
    response = {
        "type": "response",
        "id": request.get("id", -1),
    }
    try:
        response["payload"] = service.entry(request)
    except Exception as e:
        print("failed to process the request:", str(e))
        response["error"] = str(e)
    # reply the generated response
    try:
        reply(request.get("reply_to", "responses"), response)
    except Exception as e:
        print("failed to reply:", str(e))
