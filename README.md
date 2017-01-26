# Gitlab-CI Docker Machine for PHP7.1

This machine is used to deploy our PHP7 applications. It comes with PHP7 (duh!), NodeJS (npm) and Ruby (bundler).

We use it to have a consistent environment for [Fulmar](https://github.com/CORE4/fulmar) to prepare the project for deployment to different servers.

You can use this machine via a reference in your `.gitlab-ci.yml`:

```yaml
image: core4/gitlab-ci-php71

before-script:
    - echo "Your code to prepare the project here"

live:
    type: deploy
    script:
        - echo "Copy to live server"
    only: live
```

You probably want to have a deployment key ready within this machine. Read about this in the Gitlab documentation: http://docs.gitlab.com/ce/ci/ssh_keys/README.html
