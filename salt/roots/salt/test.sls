# State to run Testinfra tests

run_testinfra_tests:
  cmd.run:
    - name: pytest --verbose /home/chalkan3/dotfiles/tests/
    - cwd: /home/chalkan3/dotfiles
    - runas: chalkan3
    - require:
      - sls: dotfiles # Ensure dotfiles are applied
      - pkg: core_packages # Ensure pytest and testinfra are installed
