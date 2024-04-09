import pandas as pd

# Assuming 'dwi' is your DataFrame and 'bac1' is a column in it.
# You would read your data into a DataFrame. For demonstration, let's assume dwi is already defined.
# dwi = pd.read_csv('path_to_your_data.csv') or any other method to get your DataFrame

# Create the binary column for the cutoff

dwi = pd.read_stata('hansen_dwi.dta')

print(dwi.shape)
print(dwi.head())
dwi['dui'] = (dwi['bac1'] >= 0.08).astype(int)

import matplotlib.pyplot as plt
import seaborn as sns

# Set the aesthetic style of the plots
sns.set_theme(style="whitegrid")

# Create the plot
plt.figure(figsize=(10, 6))
plt.scatter(dwi['bac1'], dwi['dui'], alpha=0.2)
plt.axvline(x=0.08, linestyle='--', color='tomato', label='BAC 0.08 Cutoff')
plt.xlabel('BAC')
plt.ylabel('DUI (1 if BAC >= 0.08, otherwise 0)')
plt.title('BAC vs. DUI')
plt.legend()
plt.show()
