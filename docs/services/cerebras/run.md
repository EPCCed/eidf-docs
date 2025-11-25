# Running jobs

## Software

The user-nodes are equipped with a normal developer packages. If you feel that something is missing, please submit a ticket via the [Portal](https://portal.eidf.ac.uk/queries/submit)

## Virtual Environment Setup

In general, our system is compatible with the documentation from [Cerebras](https://training-docs.cerebras.ai/rel-2.6.0/getting-started/setup-and-installation) which should be followed.
However, a few small tweaks are required:

Use Cerebras [ModelZoo R2.6.0](https://github.com/Cerebras/modelzoo/tree/Release_2.6.0) for compatibility to the Cerebras machine's installed software-sdk version

You will need to pin the version of the `peft` library to `0.17.1`

For completness both the modelzoo clone and virtual environmment setup are included below:

```bash
git clone -b Release_2.6.0 https://github.com/Cerebras/modelzoo.git ./modelzoo
python3.11 -m venv modelzoo_venv
source modelzoo_venv/bin/activate
pip install --upgrade pip
pip install peft==0.17.1
pip install --editable ./modelzoo
```

## Running codes

Run as per the normal Cerebras documentation. It is advisable to run codes inside a `tmux` session so you can return to them without having to leave SSH sessions active whilst jobs run.

You may see some warnings about mount paths, e.g. `The following editable packages are not in a volume accessible to the cluster`, however these can be safely ignored.

### Example training Llama4b on a single CS3

With a suitably configured venv as above, and the modelzoo checked out:

- Navigate to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/configs/` and copy the file `params_llama3p1_8b_msl_128k.yaml` to `params_example.yaml`
- Adjust the copied `params_example.yaml` config to reduce the `max_steps` field to `50`
- Adjust the copied `params_example.yaml` config to change the `data_dir` field to `/home/y26/shared/rpj_1t_100k_llama3p1_msl8k_train`
- Navigate to `<your modelzoo checkout>/src/cerebras/modelzoo/models/nlp/llama/`
- Run using `cszoo fit --num_csx=1 configs/params_example.yaml --mount_dirs /home/<your_project>/<your_project>/<your_username>/  /home/y26/shared/ --python_paths ~/modelzoo/src/ --model_dir llama4b_u3`

### Example: Training Vision Transformer on ImageNet Mini

This tutorial will train a toy Visual transformer on a collection of captioned data, the produced model being able to input and image and output a caption.

We make use of the [imagenet-mini](https://www.kaggle.com/datasets/ifigotin/imagenetmini-1000/) dataset,  a subset of 1000 samples from the [ImageNet](https://www.image-net.org/) dataset.

1. Set up your virtual environment as described above
1. Create a space in which the model will be stored

    ```bash
    mkdir -p ~/imagenet_tutorial
    cd ~/imagenet_tutorial
    ```

1. Copy the training configuration:

    ```bash
    cp /home/y26/shared/params_vit_imagenet.yaml ~/imagenet_tutorial
    ```

1. Run the training job:

    ```bash

    cszoo fit params_vit_imagenet.yaml --num_csx=1 \
      --mount_dirs /home/y26/shared/ /home/<your_project>/<your_project>/<your_username>/ \
      --python_paths /home/<your_project>/<your_project>/<your_username>/modelzoo/src
    ```
