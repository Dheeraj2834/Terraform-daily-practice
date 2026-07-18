module "iam" {
  source = "../"

  user_name = [
    "developer1",
    "developer2"
  ]
  group_name = "Developers"
  membership_name = "dev"
}