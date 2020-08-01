enum Routes {
  login,
  forgot_password,
  register,
  my_team,
  team_details_list,
  team_information,
  profile,
  coach_list,
  new_journal
}

String getRoute(Routes routes) {
  switch (routes) {
    case Routes.login:
      return "/login";
    case Routes.forgot_password:
      return "/forgotPassword";
    case Routes.register:
      return "/register";
    case Routes.my_team:
      return "/myTeam";
    case Routes.team_details_list:
      return "/teamDetailsList";
    case Routes.team_information:
      return "/teamInformation";
    case Routes.profile:
      return "/profile";
    case Routes.coach_list:
      return "/coachList";
    case Routes.new_journal:
      return "/newJournal";
    default:
      return "/";
  }
}
