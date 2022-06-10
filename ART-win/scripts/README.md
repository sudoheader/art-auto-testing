# ⚠️FOR WINDOWS ONLY⚠️ <sub>(for now)</sub>

## Run these scripts by either downloading them or clone this repository (recommended)

Go back to https://github.com/sudoheader/art-auto-testing and do this if you haven't done it already:

```bash
git clone https://github.com/sudoheader/art-auto-testing.git
```
Otherwise: 

1. Download the zip by going to the "Code" dropdown and clicking on "Download ZIP". 

![image](https://user-images.githubusercontent.com/19720370/173125494-8146431a-054e-4450-8790-f7584209dcb3.png)

2. Extract the file and move to the `Art-win\scripts` folder to perform these test.

### NOTE: It is advisable to run the `Prereqs_${threat_group}.ps1` scripts first, so there are little to no issues when running the tests for a specific threat group.

#### It should be run in this order, for example:

`Prereqs_APT41.ps1 -> APT41_test.ps1 -> Cleanup_APT41.ps1`
