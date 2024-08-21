from wordcloud import WordCloud
import matplotlib.pyplot as plt
import numpy as np

# Words for the word cloud
text = "HTML CSS JavaScript Django Laravel React Bootstrap PHP MongoDB MySQL"

# Define the custom color function with RGB colors
def custom_color_func(word, font_size, position, orientation, random_state=None, **kwargs):
    colors = [
        "#9966FF",  # Purple (equivalent to rgba(153, 102, 255, 1))
        "#FFCE56",  # Yellow (equivalent to rgba(255, 206, 86, 1))
        "#D0E1EB"   # Light blue (rgb(208, 225, 235))
    ]
    return np.random.choice(colors)

# Create a WordCloud object
wordcloud = WordCloud(width=800, height=400, background_color='white', color_func=custom_color_func).generate(text)

# Display the generated WordCloud
plt.figure(figsize=(10, 5))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')

# Save the WordCloud as an image file
wordcloud.to_file("tech_wordcloud_custom_colors.png")

print("Word cloud saved as 'tech_wordcloud_custom_colors.png'")
