# When you need git but all you have is S3

Imagine you want to use git but you are in a constrained environment and/or there is no access to Github or an on-prem repo.

This project tries to give you git-over-s3 in a git-idiomatic way using only shell scripting and the aws CLI.

Use it if you have to use s3 as a staging area. This project cannot turn an S3 bcket into a highly concurrent git repository - great for backups and staging though.


# How to use on push side

First download the `git-remote-s3` and add it to your path.

Make sure you have configured your aws profile. If you want to use a bucket `test123` for example, make sure you can invoke this commend:

```
aws s3 ls s3://test123
```

Add a remote to your local clone:

```
git remote add my-bucket s3://test123/my/repo
```

Push to that remote:

```
git push my-bucket master
```

# How to use on the pull side

Like before, make sure you have `git-remote-s3` on your PATH and `aws` is working properly.

Then clone as usual but use the s3 protocol. Use the same path as the one during push:

```
git clone s3://test123/my/repo
```

That's it! By using [git-remote-helpers](https://git-scm.com/docs/git-remote-helpers) s3 seems almost like part of git now. This solution is suboptimal in many ways but gets the job done.


# Caveats

* You may export more branches than you specified while pushing

* If you delete an s3-backed remote you need to do manual cleanup in your .git folder to reclaim disk space (can you attach to the `git remote rm` event?)

* If you push to the same location concurrently you may get a broken repo. This is because the `--delete` options isued when syncing a local folder to the bucket and pack files are not built predictably (git versions, git gc, etc)

* marker files are not used to their full potential - may be slow

# Inner workings

This remote helper may be disk-heavy. Every time you push, the .git folder is optimized and pushed to a temp location which is then synced to the s3 bucket. Expect roughly 2x disk usage per repo.

# Local testing

If you don't have access to s3/AWS you can use [minio](https://min.io/). `make run-minio` will start minio server in you local docker, reachable on localhost:9000. Do `export AWS_CONFIG_FILE=local-minio-profile.conf` and your `aws s3 ...` commands will target it. Finally, set `export GIT_OBJECTSTORE_ENDPOINT=http://localhost:9000` so that the s3 helper will target it too (you cannot set and endpoing in the aws cli config file).

The workflow is exactly the same. If you are hacking on the project you can also set `export GIT_OBJECTSTORE_LOG=1` to get more debug output.

# Related work

* https://metamug.com/article/jgit-host-git-repository-on-s3.html is great but is another binary + JRE is not always available.

* I've based this on this great tutorial: https://rovaughn.github.io/2015-2-9.html
