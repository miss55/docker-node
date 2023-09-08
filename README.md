
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Installing Node with Docker](#installing-node-with-docker)
  - [Directory Structure](#directory-structure)
  - [Build](#build)
  - [Usage](#usage)

<!-- /code_chunk_output -->

# Installing Node with Docker

## About

Resolving Node Multiple Version Issues in Daily Development

## Directory Structure

1. `react`  Scripts and configuration files related to the React project
1. `vue`  Scripts and configuration files related to the Vue project
1. `Dockerfile`  Node Docker Build File
1. `Makefile`

## Build

1. parameters
    1. `NODE_VERSION` node version
        - [see](https://hub.docker.com/_/node/tags?page=1&name=alpine) <https://hub.docker.com/_/node/tags?page=1&name=alpine>
        NODE_VERSION?=20.6.0-alpine3.18
    1. `IMAGE_NAME` image name
        - eg `NODE_VERSION=20.6.0-alpine3.18` So, let's name the image jenson/node-20.6.`
1. command
    - `make add` // Create a default version image
    - `make add NODE_VERSION=20.6.0-alpine3.18 IMAGE_NAME=jenson/node-20.6`

    > The Dockerfile checks the version and automatically selects the appropriate Python version to create.
    > Preferably, choose version 3.15 for building. If you opt for an Alpine version above 3.15, Python will be Python 3. This is mainly to address compatibility issues with previous Node-sass compilation.

1. Remember the name of the built image, for example: jenson/node-17.5. You will need to use IMAGE_NAME below.

## Usage

1. Choose the appropriate configuration directory based on your project framework, either vue or react.
1. **If the target project already has this file, please add it manually. Otherwise, simply copy it.**
1. According to the comments in env.development.example, configure it into .env.development.
1. `make help` show help

<script>
  var copy = function(target) {
    var textArea = document.createElement('textarea')
    textArea.setAttribute('style','width:1px;border:0;opacity:0;')
    document.body.appendChild(textArea)
    textArea.value = target.innerText
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
  }

  var pres = document.querySelectorAll("pre,code")
  pres.forEach(function(pre){
    var button = document.createElement("button")
    button.className = "btn btn-sm"
    button.innerHTML = "copy"
    pre.parentNode.insertBefore(button, pre)
    button.addEventListener('click', function(e){
      e.preventDefault()
      window.global_pre = pre
      console.log(pre)
      copy(pre)
    })
  })
</script>
