#!/usr/bin/env python3
"""
yt_search.py — Free YouTube search via yt-dlp. No API key required.

Usage:
  python yt_search.py "query" [--limit 20] [--after YYYYMMDD] [--json]

Examples:
  python yt_search.py "AI agent harness" --limit 20
  python yt_search.py "claude code skills" --limit 10 --after 20250101
  python yt_search.py "agentic AI" --json
"""

import argparse
import json
import subprocess
import sys
from datetime import datetime, timedelta


def search_youtube(query: str, limit: int = 20, after: str = None) -> list[dict]:
    cmd = [
        "yt-dlp",
        f"ytsearch{limit}:{query}",
        "--print-json",
        "--no-download",
        "--flat-playlist",
        "--quiet",
        "--no-warnings",
    ]

    if after:
        cmd += ["--dateafter", after]

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    except subprocess.TimeoutExpired:
        print("Error: yt-dlp timed out", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("Error: yt-dlp not found. Install with: pip install yt-dlp", file=sys.stderr)
        sys.exit(1)

    videos = []
    for line in result.stdout.strip().splitlines():
        if not line.strip():
            continue
        try:
            data = json.loads(line)
        except json.JSONDecodeError:
            continue

        view_count = data.get("view_count") or 0
        view_text = f"{view_count:,} views" if view_count else "unknown views"

        upload_raw = data.get("upload_date")  # YYYYMMDD or None
        if upload_raw:
            try:
                dt = datetime.strptime(upload_raw, "%Y%m%d")
                upload_text = dt.strftime("%Y-%m-%d")
            except ValueError:
                upload_text = upload_raw
        else:
            upload_text = "unknown date"

        video_id = data.get("id", "")
        videos.append({
            "title":     data.get("title", "Unknown"),
            "channel":   data.get("channel") or data.get("uploader") or "Unknown",
            "views":     view_count,
            "views_text": view_text,
            "duration":  data.get("duration_string") or data.get("duration") or "?",
            "published": upload_text,
            "url":       f"https://www.youtube.com/watch?v={video_id}",
            "video_id":  video_id,
        })

    return videos


def main():
    parser = argparse.ArgumentParser(description="Search YouTube free via yt-dlp")
    parser.add_argument("query", help="Search query")
    parser.add_argument("--limit", type=int, default=20, help="Max results (default: 20)")
    parser.add_argument("--after", help="Only videos after this date (YYYYMMDD)")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    args = parser.parse_args()

    videos = search_youtube(args.query, args.limit, args.after)

    if not videos:
        print("No results found.", file=sys.stderr)
        sys.exit(1)

    if args.json:
        print(json.dumps(videos, indent=2))
        return

    # Human-readable table
    print(f"\nResults for: \"{args.query}\" ({len(videos)} videos)\n")
    print(f"{'#':<3} {'Title':<55} {'Channel':<22} {'Views':<14} {'Dur':<8} {'URL'}")
    print("-" * 140)
    for i, v in enumerate(videos, 1):
        title   = v["title"][:53] + ".." if len(v["title"]) > 55 else v["title"]
        channel = v["channel"][:20] + ".." if len(v["channel"]) > 22 else v["channel"]
        print(f"{i:<3} {title:<55} {channel:<22} {v['views_text']:<14} {v['duration']:<8} {v['url']}")
    print()


if __name__ == "__main__":
    main()
