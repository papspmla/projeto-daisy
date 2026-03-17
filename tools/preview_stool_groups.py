#!/usr/bin/env python3

import csv
import sys
from datetime import datetime
from pathlib import Path


CSV_PATH = Path("/home/paulo/projeto_daisy/media/stool/2026/stool_images_decimal.csv")
MAX_GAP_SECONDS = 600  # 10 minutos


def parse_datetime(value: str) -> datetime:
    return datetime.strptime(value.strip(), "%Y:%m:%d %H:%M:%S")


def load_rows(csv_path: Path):
    if not csv_path.exists():
        print(f"ERRO: arquivo não encontrado: {csv_path}", file=sys.stderr)
        sys.exit(1)

    rows = []
    with csv_path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)

        required = {"FileName", "DateTimeOriginal"}
        missing = required - set(reader.fieldnames or [])
        if missing:
            print(
                f"ERRO: CSV sem colunas obrigatórias: {', '.join(sorted(missing))}",
                file=sys.stderr,
            )
            sys.exit(1)

        for i, row in enumerate(reader, start=2):
            filename = (row.get("FileName") or "").strip()
            dt_raw = (row.get("DateTimeOriginal") or "").strip()

            if not filename:
                print(f"ERRO: linha {i} sem FileName", file=sys.stderr)
                sys.exit(1)

            if not dt_raw:
                print(f"ERRO: linha {i} sem DateTimeOriginal", file=sys.stderr)
                sys.exit(1)

            try:
                captured_at = parse_datetime(dt_raw)
            except ValueError:
                print(
                    f"ERRO: linha {i} com DateTimeOriginal inválido: {dt_raw}",
                    file=sys.stderr,
                )
                sys.exit(1)

            rows.append(
                {
                    "FileName": filename,
                    "DateTimeOriginal": dt_raw,
                    "captured_at": captured_at,
                }
            )

    if not rows:
        print("ERRO: CSV vazio (sem linhas de dados)", file=sys.stderr)
        sys.exit(1)

    rows.sort(key=lambda x: x["captured_at"])
    return rows


def group_rows(rows, max_gap_seconds: int):
    groups = []
    current_group = [rows[0]]

    for row in rows[1:]:
        gap = (row["captured_at"] - current_group[-1]["captured_at"]).total_seconds()

        if gap <= max_gap_seconds:
            current_group.append(row)
        else:
            groups.append(current_group)
            current_group = [row]

    groups.append(current_group)
    return groups


def main():
    rows = load_rows(CSV_PATH)
    groups = group_rows(rows, MAX_GAP_SECONDS)

    print()
    print("EVENTOS STOOL DETECTADOS")
    print("=" * 60)
    print(f"CSV: {CSV_PATH}")
    print(f"Total de imagens: {len(rows)}")
    print(f"Janela máxima entre imagens consecutivas: {MAX_GAP_SECONDS // 60} minutos")
    print(f"Total de eventos detectados: {len(groups)}")
    print("=" * 60)
    print()

    for idx, group in enumerate(groups, start=1):
        start_dt = group[0]["captured_at"]
        end_dt = group[-1]["captured_at"]

        print(f"Evento {idx}")
        print(f"  Imagens: {len(group)}")
        print(f"  Início:  {start_dt.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"  Fim:     {end_dt.strftime('%Y-%m-%d %H:%M:%S')}")

        for item in group:
            print(f"    - {item['FileName']}  [{item['DateTimeOriginal']}]")

        print()

    print("=" * 60)
    print("FIM DA PRÉVIA")
    print("=" * 60)


if __name__ == "__main__":
    main()
