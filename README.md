Minio Packaging for Synology NAS 
==

This repo can create a Synology NAS SPK file suitable for a home user. If you don't know what [Minio is, please take look](https://minio.io/).

What this is
===

Minio offers a wide-variety of features. This repo only exposes enough of Minio to get started. That is:
* fetch and build Minio for the Synology ARM platform
* package Minio in a SPK format
* Targets for ARM based Synology

Minio has elected to support Synology NAS's through [Docker Containers](https://github.com/minio/minio/issues/4210). In my opinion, targeting Docker is the correct decision for Cloud-base storage. However, if you have a consumer-grade Synology NAS, using Docker is a non-starter: I hope that this side-project will help close the gap.

As of right now, it only supports:
* non-SSL encryption
* setting the ACCESS and SECRET key

Here Be Dragons
===

Removing the Minio installation from the NAS will result in your data being deleted.

THIS ONLY WORKS FOR ARM-7 NAS's right now.

Credit where Credit is Due
===

I based this repo off the great work from a [Gitea SPK](https://github.com/flipswitchingmonkey/gitea-spk) that I also use on my Synology NAS.

Getting Started
===

You will need:
* Golang
* A Nas

After cloning/forking this repo:
* run `make`
* Go to your NAS's package manager
* Click Manually uplaod
* Follow the dialogs
* Login at `http://<NAS IP>:<port>` where `<port>` was the one you selected in the dialogs.

Pull-Requests Accepted
===

I promise not to be a jerk. If you improve, or add a feature, please send it my way; I'm happy to consider it. Opensource should be inclusive. 
