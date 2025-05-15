# Running jobs

## Software

The user-nodes are equipped with a normal developer packages. If you feel that something is missing, please submit a ticket via the [Portal](https://portal.eidf.ac.uk/queries/submit)

## Virtual Environment Setup

In general, our system is compatible with the documentation from [Cerebras](https://training-docs.cerebras.ai/rel-2.4.0/getting-started/setup-and-installation) which should be followed.
In this early phase, a few small tweaks are required:

Use Cerebras [ModelZoo 2.4.0i](https://github.com/Cerebras/modelzoo/commit/b9cb437070fe057ea52882fb8654e56753a8917c) for compatibility to the Cerebras machine's installed software-sdk version
For completness both the clone and checkout are included below:

```bash
git clone https://github.com/Cerebras/modelzoo.git ./modelzoo
cd modelzoo
git checkout b9cb437070fe057ea52882fb8654e56753a8917c 
```

Edit the file `/<path_to_your_venv>/lib/python3.8/site-packages/cerebras/appliance/appliance_manager.py` and comment out lines 986 to 1034 (should start `errors = []` and end with a single `)` on a line.)

## Running codes

Run as per the normal Cerebras documentation. It is advisable to run codes inside a `tmux` session so you can return to them without having to leave SSH sessions active whilst jobs run.

### Example training Llama4b on a single CS3

With a suitably configured venv as above, and the modelzoo checked out:

- Copy `/home/y26/shared/params_tr.yaml` to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/configs/`
- Navigate to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/`
- Run using `python run.py CSX --num_csx=1 --mode train --params configs/params_tr.yaml --mount_dirs /home/<your_project>/<your_project>/<your username> /home/y26/shared/ --python_paths <path to your modelzoo checkout>/src/ --max_steps 50 --model_dir llama4b_u3`

### Example: Training Vision Transformer on ImageNet Mini

This tutorial will train a toy Visual transformer on a collection of captioned data, the produced model being able to input and image and output a caption.

We make use of the [imagenet-mini](https://www.kaggle.com/datasets/ifigotin/imagenetmini-1000/) dataset,  a subset of 1000 samples from the [ImageNet](https://www.image-net.org/) dataset.

1. Set up your virtual environment as described above
2. Create a space in which the model will be stored

    ```bash
    mkdir -p ~/imagenet_tutorial
    cd ~/imagenet_tutorial
    ```

3. Copy the training configuration:

    ```bash
    cp /home/y26/shared/params_vit_imagenet.yaml ~/imagenet_tutorial
    ```

4. Run the training job:

    ```bash

    cszoo fit params_vit_imagenet.yaml --num_csx=1 \
      --mount_dirs /home/y26/shared/ /home/<your_project>/<your_project>/<your_username>/ \
      --python_paths /home/<your_project>/<your_project>/<your_username>/modelzoo/src
    ```
