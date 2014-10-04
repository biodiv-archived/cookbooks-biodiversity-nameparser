biodiversity-nameparser Cookbook
=============
Installs and configures [biodiversity taxonomic nameparser](https://github.com/GlobalNamesArchitecture/biodiversity) as a upstart or init daemon process.

Requirements
============

## Platforms

* Ubuntu 14.04 LTS

Tested on:

* Ubuntu 14.04 LTS


### Cookbooks
Requires the following cookbooks

* `apt` - to install ruby 2.0 and gem 2.0.


Attributes
============

* `node[:nameparser][:home]` - The home folder for the name parser. Primarily holds the PID file.
* `node[:nameparser][:user]` - The user running the nameparser daemon.
* `node[:nameparser][:group]` - The group running the nameparser daemon.

The default values for these attributes can be found in `attributes/default.rb`

Recipes
=======
* `dedfault.rb` - Installs ruby, gem and biodiversity gem and sets up upstart / init conf files. Start the nameparser service as well.

Chef Solo Note
==============

You can install solr on tomcat as follows.

Create a file solr.json with the following contents. 

    {
        "nameparser": {
            "user": "biodiv",
            "group": "biodiv"
        },
        "run_list": [
            "recipe[biodiversity-nameparser]"
        ]
    }

License and Author
==================

- Author:: Ashish Shinde (<ashish@strandls.com>)
- Author:: Sandeep Tadekar (<sandeept@strandls.com>)
- Author:: Prabhakar Rajagopal (<prabha@strandls.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
