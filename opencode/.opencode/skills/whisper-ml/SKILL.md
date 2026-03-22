---
name: whisper-mlx
description: Transcribe audio/video files using mlx-whisper on Apple Silicon. Use when the user wants to transcribe, subtitle, or convert speech to text from audio or video files.
---

# Whisper MLX Transcription

Transcribe audio/video files using mlx-whisper, optimized for Apple Silicon (MLX backend).

## Setup

Create a venv and install mlx-whisper (one-time setup):

```bash
python3 -m venv /tmp/whisper-mlx-venv
source /tmp/whisper-mlx-venv/bin/activate
pip install mlx-whisper
```

## Usage

```bash
source /tmp/whisper-mlx-venv/bin/activate
mlx_whisper $ARGUMENTS --model mlx-community/whisper-large-v3-mlx --output-format txt
```

### Common flags

- `--language es` — specify language (skip for auto-detect)
- `--output-dir ./output` — output directory
- `--output-format {txt,vtt,srt,tsv,json,all}` — output format
- `--task translate` — translate to English instead of transcribing

### Model options (via `--model`)

| Model | HuggingFace repo | Speed | Quality |
|-------|-------------------|-------|---------|
| large-v3 | `mlx-community/whisper-large-v3-mlx` | ~21s/2min audio | Best |
| medium | `mlx-community/whisper-medium-mlx` | Faster | Good |
| small | `mlx-community/whisper-small-mlx` | Fastest | OK |

Default to `large-v3` unless the user asks for speed.

### Example

```bash
source /tmp/whisper-mlx-venv/bin/activate
mlx_whisper recording.mp4 --model mlx-community/whisper-large-v3-mlx --language es --output-dir ./output --output-format txt
```

## Notes

- Models are cached in `~/.cache/huggingface/` after first download
- large-v3 is ~3 GB on first download, then instant
- CLI flags use **dashes** not underscores (e.g. `--output-dir`, not `--output_dir`)
- MLX is ~8x faster than CPU and ~5x faster than MPS (PyTorch) for Whisper on Apple Silicon
- Supports all formats that ffmpeg supports (mp4, mp3, wav, m4a, webm, etc.)
