import argparse
import numpy as np
import tskit

def parse_args():
    parser = argparse.ArgumentParser(
        description="calculate fst"
    )
    parser.add_argument("--trees",  "-t", required=True, help="tskit trees")
    parser.add_argument("--poplabels",  "-p", required=True, help="poplabels")
    parser.add_argument("--windows", "-w", required=True, help="npy output, genomic windows")
    parser.add_argument("--fsts", "-f", required=True, help="npy output, fsts")
    return parser.parse_args()

def main():
    args = parse_args()

    pops = []
    with open(args.poplabels,'r') as f:
      next(f)
      for line in f:
        pops.append(line.strip().split()[1])

    sp1 = [i for i,j in enumerate(pops) if j[:3]=='cor']
    sp2 = [i for i,j in enumerate(pops) if j[:3]=='cnx']

    ts = tskit.load(args.trees)

    window = list(ts.breakpoints())
    fst = ts.Fst([sp1,sp2], windows=window, mode='branch')

    np.save(args.windows, window)
    np.save(args.fsts, fst)

if __name__ == "__main__":
    main()


