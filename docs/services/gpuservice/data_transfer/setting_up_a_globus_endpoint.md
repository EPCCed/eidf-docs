# Setting up a Globus Endpoint

Before beginning this setup, it is a good idea to make sure you have a [Globus account](https://app.globus.org) set up.  

## Creating the Service, Volume and Container

1. Log into your VM, either through the [VDI Portal](https://eidf-vdi.epcc.ed.ac.uk/vdi) or through [SSH](https://epcced.github.io/eidf-docs/access/ssh/).  

2. Clone the [globus-connect project from Gitlab](https://gitlab.nrp-nautilus.io/prp/globus-connect.git).  

3. Open the globus-connect-volume.yaml file in your text editor of choice, and change the storageClassName from “rook-ceps-block” to “csi-rbd-sc”.  The file should now read as:- 

    ``` yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: globus-connect-data
    spec:
      storageClassName: csi-rbd-sc
      accessModes:
      - ReadWriteOnce
      resources:
       requests:
         storage: 50Gi
    ```

    This PVC will be where any data transfered over the endpoint is saved.  However, we also need a second PVC to save the endpoints configuration.  To create this, create a new yaml file called "globus-connect-volume-epinfo", and enter in the folllowing:- 

    ``` yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: globus-connect-epinfo
    spec:
      storageClassName: csi-rbd-sc
      accessModes:
      - ReadWriteOnce
      resources:
       requests:
         storage: 10Gi
    ```

4. Open the globus-connect.yaml file, and change/add the following lines:- 

    ``` yaml
    ......
        args: ['/bin/bash', '-c', 'chown -R gridftp.gridftp /data && su - gridftp -c "cd /home/gridftp && chmod 744 /home/gridftp/globus-connect-personal.sh && /home/gridftp/globus-connect-personal.sh"']
        volumeMounts:
            - mountPath: /data/datapvc
              name: globus-connect-data
            - mountPath: /data/gridftp-save
	      name: globus-connect-epinfo
      volumes:
      - name: globus-connect-data
        persistentVolumeClaim:
          claimName: globus-connect-data
	- name: globus-connect-epinfo
        persistentVolumeClaim:
          claimName: globus-connect-epinfo

    ```

5. Run the following commands, replacing “project_namespace” with your namespace on the machine you’re using:- 

    ``` bash
    kubectl create -f globus-connect-service.yaml -n project_namespace
    kubectl create -f globus-connect-volume.yaml -n project_namespace
    kubectl create -f globus-connect-volume-epinfo.yaml -n project_namespace
    kubectl create -f globus-connect.yaml -n project_namespace
    ```
    You can then check that your pod is running:- 

    ``` bash
    kubectl get pods -n project_namespace
    ```

6. Connect to the pod that you just created:- 

    ``` bash
    kubectl exec -it globus-connect-0 -n project_namespace -- bash
    ```

## Creating/Configuring the Endpoint

1. Change from superuser to the gridftp user:-

    ``` bash
    su - gridftp
    ```

2. Log into your Globus account;
    - Enter the following command:- 
        ``` bash
        globus login --no-local-server
        ```
        This will give you an output similar to the following:- 

        ``` bash
        Please authenticate with Globus here:
        ------------------------------------
        https://auth.globus.org/v2/oauth2/authorize?prompt=login&access_type=offline&state=_default&redirect_uri=https …
        … &scope=openid+profile+email+uuview_identity_set+urn%3Aglobus%3Aauth%3Ascope%3Atransfer.api.globus.org%3Aall
        ------------------------------------
        Enter the resulting Authorization Code here:
        ```

    - Copy and paste the URL into a browser window.  At this point you will be prompted to log into your Globus account.  Do this, and then run through the setup until you are presented with an authorisation code.  Copy this into the terminal and press enter.  

    - You should now be follwed in.  You can confirm this by entering:-
        ``` bash
        globus whoami
        ```
        This should return your Globus username.  

3. Create your endpoint by entering the following line:-  

    ``` bash
    globus endpoint create --personal <your endpoint name> | tee endpoint-info
    ```

    If successful, this should return the following:- 
    ``` bash
    Endpoint created successfully
    Endpoint ID: <Your unique endpoint ID>
    Setup Key: <Your unique setup key>
    ```

4. Navigate to the globesconnectpersonal folder, and then run globusconnectpersonal.  The folder will be appended with the current version number, so its a good idea to run ```ls``` to confirm the folders name:-

    ``` bash
    cd globusconnectpersonal-3.x.x/
    ./globusconnectpersonal -setup <Your unique setup key>
    ```

    You can now verify that the endpoint was set up correctly:- 

    ``` bash
    globus endpoint search --filter-scope my-endpoints

    ID                | Owner                  | Display Name 
    ------------------| -----------------------| -------------
    087ecee8-d7cd-... | YouCredential@your.org | <your endpoint name>
    ```

5. Start the endpoint:- 

    ``` bash
    ./globusconnectpersonal -start &
    ```

    You should be able to confirm that this was worked correctly by navigating to your [Globus accounts Collections](https://app.globus.org/file-manager/collections), and checking to see if your Endpoint is listed.  


## Making the Setup Permanent using PVC

Currently, if the container was restarted, it would need to be reconfigured over again.  We can avoid this by saving the endpoint setup in the extra PVC we created earlier.  

1. Switch back to the superuser.  You can do this by just entering ```exit```.  

2. Enter the following lines to copy over the necessary files:-

    ``` bash
    cd ~gridftp/
    cp -p -r .globus* /data/gridftp-save/
    cp -p endpoint-info /data/gridftp-save/
    ```

3. When you first configure the globus personal endpoint, the default path will be ~/ as defined in ~/.globusonline/lta/config-paths.  To persist your data, you must transfer it to /data/datapvc/.  To allow access to this path in Globus, run this command:-

    ``` bash
    echo "/data/datapvc/,0,1" >> ~/.globusonline/lta/config-paths
    ```
    You can confirm that this worked by entering the following command:- 
    
    ``` bash
    cat .globusonline/lta/config-paths
    ```
    
    This should return:- 

    ``` bash
    ~/,0,1
    /data/datapvc/,0,1
    ```


4. At this point, you will need to re-run the following command to re-copy your changes to the /data/gridftp-save/ directory:- 

    ``` bash
    cp -p -r ~/.globus* /data/gridftp-save/
    ```

At this point, it is a good idea to confirm that any changes you make to the Endpoint directory in the Globus webapp are reflected in the endpoint itself.  A very simple way to check this is to select your endpoint from your [Globus accounts Collections](https://app.globus.org/file-manager/collections), navigate to /data/gridftp-save/, and then add a new folder.  You should then be able to ```cd``` into the same directory in the endpoint itself and see the new folder there as well.  

## Accessing Data on the Persistent Storage

You can now use a second pod to retrieve transferred data from the PVC.  

1. Delete the statefulset that you created at the start of the guide (this will by default be called globus-connect):-

    ``` bash
    kubectl delete statefulset globus-connect -n project_namespace
    ```

2. Create a new .yaml file (in this case called accessPod.yaml), and enter the following:-

    ``` yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: globus-connect-pod
    spec:
      containers:
      - name: globus-connect-pod
        image: ubuntu:latest
        resources:
          limits:
            memory: 100Mi
            cpu: 100m
          requests:
            memory: 100Mi
            cpu: 100m
        imagePullPolicy: Always
        args: ["/bin/bash", "-c", "sleep infinity"]
        volumeMounts:
            - mountPath: /datapvc
              name: globus-connect-data
      volumes:
      - name: globus-connect-data
        persistentVolumeClaim:
          claimName: globus-connect-data
    ```

3. Schedule this new pod, ensuring that it is in the same namespace as the Globus endpoint:- 

    ``` bash
    kubectl create -f accessPod.yaml -n project_namespace
    ```

    You will now be able to connect to this pod and access the data in your endpoint at the directory ```/datapvc/```.  

4. You can then re-create the globus-connect statefulset by re-entering the following command from the initial setup:-  

    ``` bash
    kubectl create -f globus-connect.yaml -n project_namespace
    ```
