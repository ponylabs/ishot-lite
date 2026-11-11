.PHONY: all test check
all:
	python3 build.py

check:
	cd .. && python3 -B scripts/check_harness.py
	cd .. && python3 -B -m unittest discover -s tests -p 'test_*.py'
	python3 -B audit.py --inputs-only

test: check
	$(MAKE) all
	python3 test.py
