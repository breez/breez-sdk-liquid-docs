# Breez SDK - *Liquid* 
## Python CLI Example

This is a basic CLI to send and receive payments in Python using Breez SDK - *Liquid*

### Setup

Install poetry using [your preferred method](https://python-poetry.org/docs/#installation). Then once poetry is installed, you can install the CLIs dependencies using `poetry install`.

If you have a pre-existing mnemonic phrase you want to use, save the phrase into a `phrase` file. If no `phrase` file exists when the CLI is run a new mnemonic phrase will be generated.

### Using the CLI

You can list a set of basic commands using: `poetry run cli -h`
```bash
usage: Pythod SDK Example [-h] {receive,send} ...

Simple CLI to receive/send payments

optional arguments:
  -h, --help      show this help message and exit

subcommands:
  {receive,send}
    receive       Receive a payment
    send          Send a payment
```

#### Receive a payment
You can receive a payment via Lightning, Bitcoin or Liquid by running: 
`poetry run cli receive -m <PAYMENT_METHOD> -a <AMOUNT>`. 

For more information run: `poetry run cli receive -h`

#### Send a payment
You can send a payment via Lightning or Liquid by running: 
`poetry run cli send -a <DESTINATION> -a <AMOUNT>`. 

For more information run: `poetry run cli send -h`