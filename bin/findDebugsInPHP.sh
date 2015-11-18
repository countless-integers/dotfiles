#!/bin/bash
ag --php '(?<=\s)(ddd?|var_dump|die\;)'
