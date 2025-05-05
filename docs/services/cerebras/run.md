# Running jobs

## Software

The user-nodes are equipped with a normal developer packages. If you feel that something is missing, please submit a ticket via the [Portal](https://portal.eidf.ac.uk/queries/submit)

## Virtual Environment Setup

In general, our system is compatible with the documentation from [Cerebras](https://training-docs.cerebras.ai/rel-2.4.0/getting-started/setup-and-installation) which should be followed.<br> In this early phase, one small tweak is required:

Edit the file `/<path_to_your_venv>/lib/python3.8/site-packages/cerebras/appliance/appliance_manager.py` and comment out lines 986 to 1034 (should start `errors = []` and end with a single `)` on a line.)

## Running codes

Run as per the normal Cerebras documentation. It is advisable to run codes inside a `tmux` session so you can return to them without having to leave SSH sessions active whilst jobs run.

## Example training Llama4b on a single CS3

With a suitably configured venv as above, and the modelzoo checked out:

- Copy `/home/y26/shared/params_tr.yaml` to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/configs/`
- Navigate to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/`
- Run using `python run.py CSX --num_csx=1 --mode train --params configs/params_tr.yaml --mount_dirs /home/<your_project>/<your_project>/<your username> /home/y26/shared/ --python_paths <path to your modelzoo checkout>/src/ --max_steps 50 --model_dir llama4b_u3`
