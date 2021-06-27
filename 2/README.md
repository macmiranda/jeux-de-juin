## k8s FTW
 
 Write a Kubernetes `StatefulSet` to run the container from [1](../1), using persistent volume claims and resource limits.


## My Comments

I've created the resources in their own namespace although not required, like to keep apps logically separated.

A few things I'm not sure about:
- Didn't know what kind of `StorageClass` would be available in the cluster. So that will need to be changed
- Set the `accessModes` to `ReadWriteMany` as all the pods in the `StatefulSet` will need rw access to it
- Set the `volumeMode` to `Filesystem` because the `Pods` will need to manage locking of files
- That being said, I'm not sure whether Litecoin itself can manage file locking and distributed computing with a single PV.
- Helm was not mentioned so I kept things simple and created a single manifest file.
