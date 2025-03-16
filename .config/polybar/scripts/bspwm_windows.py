#!/usr/bin/env python3

import subprocess
import re

def get_window_titles():
    try:
        # Get all window IDs in the current desktop
        result = subprocess.run(
            ["bspc", "query", "-N", "-n", ".window", "-d", "focused"],
            capture_output=True, text=True, check=True
        )
        
        window_ids = result.stdout.strip().split("\n")
        
        # Filter out empty entries
        window_ids = [wid for wid in window_ids if wid]
        
        # Get focused window
        focused_window = None
        try:
            focused_result = subprocess.run(
                ["bspc", "query", "-N", "-n", "focused"],
                capture_output=True, text=True, check=True
            )
            focused_window = focused_result.stdout.strip()
        except Exception:
            pass
        
        window_data = []
        
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
                    if len(title) > 70:
                        title = title[:12] + "..."
                    
                    # Mark if this is the focused window
                    is_focused = (wid == focused_window)
                    
                    window_data.append({
                        "id": wid,
                        "title": title,
                        "focused": is_focused
                    })
            except Exception:
                continue
        
        return window_data
    except Exception as e:
        return []

def format_for_polybar(window_data):
    # Define colors - these match the Nord theme in your polybar config
    bg_color = "#D8DEE9"  # shade3 from your config - background for center section
    focused_bg = "#ECEFF4"  # shade1 - white for focused window
    focused_fg = "#2E3440"  # shade7 - dark for text on focused window
    unfocused_bg = "#5E81AC"  # shade8/frost4 - blue for unfocused windows
    unfocused_fg = "#ECEFF4"  # shade1 - white text for unfocused windows

    if not window_data:
        # Start with the background color
        return f"%{{B{bg_color}}}%{{F{focused_fg}}}  Desktop  %{{F-}}%{{B-}}"
    
    # Start with polybar's background color transitioning to our section
    formatted_output = f"%{{B{bg_color}}}"
    
    for window in window_data:
        title = window["title"]
        is_focused = window["focused"]
        
        # Format based on focus state
        if is_focused:
            # Focused window - white background, dark text
            formatted_output += f"%{{B{focused_bg}}}%{{F{focused_fg}}}  {title}  %{{F-}}%{{B{bg_color}}}"
        else:
            # Unfocused window - blue background, light text
            formatted_output += f"%{{B{unfocused_bg}}}%{{F{unfocused_fg}}}  {title}  %{{F-}}%{{B{bg_color}}}"
    
    # End with transition back to default background
    formatted_output += "%{B-}"
    
    return formatted_output

if __name__ == "__main__":
    window_data = get_window_titles()
    output = format_for_polybar(window_data)
    print(output)
