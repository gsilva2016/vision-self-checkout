# Automated Self Checkout

![CodeQL](https://github.com/intel-retail/automated-self-checkout/actions/workflows/codeql.yaml/badge.svg?branch=main) ![GolangTest](https://github.com/intel-retail/automated-self-checkout/actions/workflows/gotest.yaml/badge.svg?branch=main) ![DockerImageBuild](https://github.com/intel-retail/automated-self-checkout/actions/workflows/build.yaml/badge.svg?branch=main)  [![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/intel-retail/automated-self-checkout/badge)](https://api.securityscorecards.dev/projects/github.com/intel-retail/automated-self-checkout) [![GitHub Latest Stable Tag](https://img.shields.io/github/v/tag/intel-retail/automated-self-checkout?sort=semver&label=latest-stable)](https://github.com/intel-retail/automated-self-checkout/releases)

> **Warning**  
> The **main** branch of this repository contains work-in-progress development code for the upcoming release, and is **not guaranteed to be stable or working**.
>
> **The source for the latest release can be found at [Releases](https://github.com/intel-retail/automated-self-checkout/releases).**


## Table of Contents

- [Prerequisites](#prerequisites)
- [QuickStart](#quickstart)
- [Documentation](#documentation)
- [Known issues](#known-issues)
- [Disclaimer](#disclaimer)
- [Datasets & Models Disclaimer](#datasets--models-disclaimer)

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/ubuntu/) 
- [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)
- [Docker Compose v2](https://docs.docker.com/compose/) (Optional)
- Intel hardware (CPU, GPU, dGPU)

## QuickStart

0. Simply run:

(If this is the first time, it will take some time to download videos, models, docker images and build containers)

```
make run-demo
```

More detailed instructions:

1. Build the project

```
make build-python-apps
```

2. Download sample videos
```
cd benchmark-scripts
./download_sample_videos.sh
```

3. Run camera simulator:

(Go back to the root directory)

```
cd ..
make run-camera-simulator
```

4. Run object detection:

(This first command will take some time while it downloads the models for the first time)
```
PIPELINE_PROFILE="object_detection" RENDER_MODE=1 sudo -E ./run.sh --platform core --inputsrc rtsp://127.0.0.1:8554/camera_1
```
<div align="center"><img src="detection.gif" width=900/></div>

Repeat the same command changing PIPELINE_PROFILE to "classification" or "instance_segmentation"

You can check the pipeline's results by following this [guide](https://intel-retail.github.io/automated-self-checkout/OVMS/quick_pipelinerun.html#run-instance-segmentation)

For more advanced parameters, follow this [guide](https://intel-retail.github.io/automated-self-checkout/OVMS/pipelinerun.html#run-pipeline-with-different-input-sourceinputsrc-types)

5. Tear everything down:

```
make clean-all
```

## Documentation

- [Open source code for setup, install, and execution of software, with complete developer documentation](https://intel-retail.github.io/automated-self-checkout/)
- [Developer focused website to enable developers to engage and build our partner community](https://www.intel.com/content/www/us/en/developer/articles/reference-implementation/automated-self-checkout.html)
- [LinkedIn blog illustrating the automated self checkout use case more in detail](https://www.linkedin.com/pulse/retail-innovation-unlocked-open-source-vision-enabled-mohideen/)

## Smoke tests

Smoke tests can be run from the command line:

- to run smoke tests for pipelines: `make run-smoke-tests`
- to run smoke tests for benchmark: `(cd ./benchmark-scripts || true; ./smoke_test_benchmark.sh)`  (this can take long time because of stream density test)

## Known issues

- Once barcode is detected and decoded, barcode label text is displayed inside the object even if barcode is not visible.
- Overlapping object detection label (gvatrack adds its own labels)

## Disclaimer

GStreamer is an open source framework licensed under LGPL. See https://gstreamer.freedesktop.org/documentation/frequently-asked-questions/licensing.html?gi-language=c.  You are solely responsible for determining if your use of Gstreamer requires any additional licenses.  Intel is not responsible for obtaining any such licenses, nor liable for any licensing fees due, in connection with your use of Gstreamer.

Certain third-party software or hardware identified in this document only may be used upon securing a license directly from the third-party software or hardware owner. The identification of non-Intel software, tools, or services in this document does not constitute a sponsorship, endorsement, or warranty by Intel.

## Datasets & Models Disclaimer

To the extent that any data, datasets or models are referenced by Intel or accessed using tools or code on this site such data, datasets and models are provided by the third party indicated as the source of such content. Intel does not create the data, datasets, or models, provide a license to any third-party data, datasets, or models referenced, and does not warrant their accuracy or quality.  By accessing such data, dataset(s) or model(s) you agree to the terms associated with that content and that your use complies with the applicable license.

Intel expressly disclaims the accuracy, adequacy, or completeness of any data, datasets or models, and is not liable for any errors, omissions, or defects in such content, or for any reliance thereon. Intel also expressly disclaims any warranty of non-infringement with respect to such data, dataset(s), or model(s). Intel is not liable for any liability or damages relating to your use of such data, datasets or models.
