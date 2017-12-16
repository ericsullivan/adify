defmodule Adifier.PackageManager do
  @moduledoc """
  """

  @needsudo ~w(apt apt-get yum)
  @cmdopts [into: IO.stream(:stdio, :line)]

  def package_managers(:ubuntu), do: ~w(apt apt-get)
  def package_managers(:centos), do: ~w(yum)
  def package_managers(:mac), do: ~w(brew)

  def update_cmd(pm), do: invoke_cmd(pm, with: "update")

  def invoke_cmd(pm, with: str) when pm in @needsudo do
    System.cmd("sudo", [pm | String.split(str)], @cmdopts)
  end
  def invoke_cmd(pm, with: str) do
    System.cmd(pm, String.split(str), @cmdopts)
  end
end
