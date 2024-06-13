//
//  DeltaColorValueView.swift
//  Color Palette
//
//  Created by Denis Dmitriev on 08.06.2024.
//

import SwiftUI

struct DeltaColorValueView: View {
    @Binding var reference: Color
    @Binding var sample: Color
    
    @State private var deltaE: Double? = nil
    @State private var formula: ColorDistanceFormula = .CIEDE2000
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Color Difference")
                        
                        Text(formula.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    switch deltaE {
                    case .some(let deltaE):
                        Text("ΔE " + deltaE.formatted())
                            .foregroundStyle(.primary)
                            .fontWeight(.semibold)
                    case .none:
                        Text("Empty")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .font(.system(size: 20, weight: .regular))
        .onChange(of: [reference, sample], { _, newValues in
            let reference = newValues[0]
            let sample = newValues[1]
            
            getDeltaE(reference: reference, sample: sample)
        })
        .onAppear {
            getDeltaE(reference: reference, sample: sample)
        }
    }
    
    private func getDeltaE(reference: Color, sample: Color) {
        let reference = UIColor(reference).cgColor
        let sample = UIColor(sample).cgColor
        
        let deltaE = reference.difference(sample: sample, formula: formula)
        self.deltaE = deltaE.roundedDecimal(2)
    }
}

#Preview {
    DeltaColorValueView(reference: .constant(Color.white), sample: .constant(Color.blue))
}
