import Publish

extension DeploymentMethod {
  static func remoteServer() -> Self {
    git("ssh://root@207.154.252.236/var/repo/tie_website.git")
  }
}
