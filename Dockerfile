ARG NODE_VERSION
FROM node:${NODE_VERSION}
WORKDIR /usr/src/app

# Set the source mirror
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

# A simple check through the Alpine version that comes with Node.
RUN if echo ${NODE_VERSION} | grep -E "alpine3.15|alpine3.14|alpine.3.13|alpine.3.12|alpine.3.11"; then apk update && apk add --update git openssh python2 python2-dev make g++; else apk update && apk add --update git openssh python3 python3-dev make g++;  fi


# set yarn config and npm config
RUN yarn config set registry http://mirrors.cloud.tencent.com/npm &&\
  yarn config set sass_binary_site https://npmmirror.com/mirrors/node-sass  &&\
  yarn config set electron_mirror https://npmmirror.com/mirrors/electron/  &&\
  yarn config set puppeteer_download_host https://npmmirror.com/mirrors &&\
  yarn config set chromedriver_cdnurl https://npmmirror.com/mirrors/chromedriver &&\
  yarn config set operadriver_cdnurl https://npmmirror.com/mirrors/operadriver &&\
  yarn config set phantomjs_cdnurl https://npmmirror.com/mirrors/phantomjs &&\
  yarn config set selenium_cdnurl https://npmmirror.com/mirrors/selenium &&\
  yarn config set node_inspector_cdnurl https://npmmirror.com/mirrors/node-inspector 

RUN export SASS_BINARY_SITE=https://npmmirror.com/mirrors/node-sass \
  && export ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/  \
  && export PUPPETEER_DOWNLOAD_HOST=https://npmmirror.com/mirrors \
  && export CHROMEDRIVER_CDNURL=https://npmmirror.com/mirrors/chromedriver \
  && export PHANTOMJS_CDNURL=https://npmmirror.com/mirrors/phantomjs \
  && export SELENIUM_CDNURL=https://npmmirror.com/mirrors/selenium \
  && export NODE_INSPECTOR_CDNURL=https://npmmirror.com/mirrors/node-inspector

# In npm 7 and later, use key=value.
RUN if [ 9 -ge `npm -v | cut -d '.' -f 1` ] ;then npm config set registry=http://mirrors.cloud.tencent.com/npm/ ; fi
RUN if [ 6 -le `npm -v | cut -d '.' -f 1` ] ;then npm config set registry http://mirrors.cloud.tencent.com/npm/ ; fi


#When building, the user is root, but when executing, the user is node. Therefore, you need to copy the configuration files to the node user's directory, or else the settings won't take effect.
RUN touch .npmrc && cp ~/.npmrc  /home/node/ && chown node:node /home/node/.npmrc
