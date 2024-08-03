{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    tmux 
    git
  ];
}
