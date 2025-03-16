#!/usr/bin/env python3

import subprocess
import re

def get_window_titles():
    # Default output
    titles = []
    
    try:
        # Get all window IDs in the current desktop
        result = subprocess.run(
            ["bspc", "query", "-N", "-n", ".window", "-d", "focused"],
            capture_output=True, text=True, check=True
        )
        
        window_ids = result.stdout.strip().split("\n")
        
        # Filter out empty entries
        window_ids = [wid for wid in window_ids if wid]
        
        if not window_ids:
            return ["Desktop"]
        
        # Get window titles for each ID
        for wid in window_ids:
            try:
                # Using xprop to get window name
                result = subprocess.run(
                    ["xprop", "-id", wid, "WM_NAME"],
                    capture_output=True, text=True, check=True
                )
                
                # Extract the title using regex
                match = re.search(r'WM_NAME\(\w+\) = "(.+)"', result.stdout)
                if match:
                    title = match.group(1)
                    # Truncate long titles
                    if len(title) > 15:
                        title = title[:15] + "..."
                    titles.append(title)
            except Exception:
                continue
        
        # If no valid titles found, show Desktop
        if not titles:
            return ["Desktop"]
            
        return titles
        
    except Exception as e:
        # Return a dummy value in case of errors
        return ["Terminal"]

if __name__ == "__main__":
    titles = get_window_titles()
    print(" | ".join(titles))
