# Running jobs

## Software

The user-nodes are equipped with a normal developer packages. If you feel that something is missing, please submit a ticket via the [Portal](https://portal.eidf.ac.uk/queries/submit)

## Virtual Environment Setup

In general, our system is compatible with the documentation from [Cerebras](https://training-docs.cerebras.ai/rel-2.4.0/getting-started/setup-and-installation) which should be followed.
In this early phase, a few small tweaks are required:

Edit the file `/<path_to_your_venv>/lib/python3.8/site-packages/cerebras/appliance/appliance_manager.py` and comment out lines 986 to 1034 (should start `errors = []` and end with a single `)` on a line.)

The current Cerebras firmware version is 2.4.0. If you have the wrong version installed, an error will be raised on running `cerebras_install_check`:

```bash
ERROR:cerebras:Cerebras Component Mismatch Check Installation:
COMPONENT_NAME_CLUSTER_SERVER has version: 2.4.0 but client has 2.4.3.
In order to use this cluster, you must install 2.4.0 of the client.
```

Installation of Cerebras firmware version 2.4.0 into your virtual environment is done using the following command:

```bash
pip install cerebras-sdk==2.4.0
```

## Running codes

Run as per the normal Cerebras documentation. It is advisable to run codes inside a `tmux` session so you can return to them without having to leave SSH sessions active whilst jobs run.

## Example training Llama4b on a single CS3

With a suitably configured venv as above, and the modelzoo checked out:

- Copy `/home/y26/shared/params_tr.yaml` to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/configs/`
- Navigate to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/`
- Run using `python run.py CSX --num_csx=1 --mode train --params configs/params_tr.yaml --mount_dirs /home/<your_project>/<your_project>/<your username> /home/y26/shared/ --python_paths <path to your modelzoo checkout>/src/ --max_steps 50 --model_dir llama4b_u3`
