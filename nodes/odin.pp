node odin {
  include role::server

  # Customer Groups
  Account::User <| tag == customer |>
  Group <| tag == customer |>
  Ssh_authorized_key <| tag == customer |>

  $ssh_customer = [
    "motorola", # support:767
  ]

  ssh::allowgroup { "prosvc": }
  ssh::allowgroup { "support": }
  ssh::allowgroup { $ssh_customer: chroot => true, tcpforwarding => true }
  ssh::allowgroup { "developers": }
}
