# Rabbit Worker

## 1. Prepare the python environment for your IDE to use it

```bash
$ virtualenv --python `which python3.8` venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```

## 2. Run the rabbit worker in development mode:

```bash
# in console 1
# cd rabbitWorker repo
$ make dev

# You can also run the integration tests:
# in console 2
# cd rabbitWorker repo
$ make test
```

