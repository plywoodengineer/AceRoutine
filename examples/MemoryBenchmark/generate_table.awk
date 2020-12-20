#!/usr/bin/gawk -f
#
# Usage: generate_table.sh < ${board}.txt
#
# Takes the file generated by collect.sh and generates an ASCII
# table that can be inserted into the README.md.

BEGIN {
  NUM_FEATURES = 4
  labels[0] = "Baseline"
  labels[1] = "One Coroutine"
  labels[2] = "Two Coroutines"
  labels[3] = "Scheduler, One Coroutine"
  labels[4] = "Scheduler, Two Coroutines"
  record_index = 0
}
{
  u[record_index]["flash"] = $2
  u[record_index]["ram"] = $4
  record_index++
}
END {
  base_flash = u[0]["flash"]
  base_ram = u[0]["ram"]
  for (i = 0; i < NR; i++) {
    u[i]["d_flash"] = u[i]["flash"] - base_flash
    u[i]["d_ram"] = u[i]["ram"] - base_ram
  }

  printf("+--------------------------------------------------------------+\n")
  printf("| functionality                   |  flash/  ram |       delta |\n")
  printf("|---------------------------------+--------------+-------------|\n")
  printf("| %-31s | %6d/%5d | %5d/%5d |\n",
      labels[0], u[0]["flash"], u[0]["ram"], u[0]["d_flash"], u[0]["d_ram"])
  printf("|---------------------------------+--------------+-------------|\n")
  for (i = 1; i <= NUM_FEATURES; i++) {
    printf("| %-31s | %6d/%5d | %5d/%5d |\n",
        labels[i], u[i]["flash"], u[i]["ram"], u[i]["d_flash"], u[i]["d_ram"])
  }
  printf("+--------------------------------------------------------------+\n")
}